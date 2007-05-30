Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbXE3MQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbXE3MQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 08:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbXE3MQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 08:16:20 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:60034 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640AbXE3MQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 08:16:19 -0400
Date: Wed, 30 May 2007 08:16:18 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6] Linux Kernel Markers
Message-ID: <20070530121618.GD22567@Krystal>
References: <20070529183725.179570071@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070529183725.179570071@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:15:40 up 1 day, 20:54,  5 users,  load average: 1.40, 2.06, 1.71
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Same here : it applies at the end of 2.6.21-mm2, not 2.6.22-mm1 as said
in my message.

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Hi,
> 
> The Linux Kernel Markers have been reworked to now depend on the "Conditional
> Calls" as a basic infrastructure for enabling the calls to the function
> pointers (probes).
> 
> The second major change in this release is the use of a hash table to keep track
> of the enabled markers : it permits it issue the marker_arm_probe before loading
> a module containing the specified probe. The probe connexion to the marker is
> done both when the marker is armed and at module load time. It fixes an
> unexpected behavior of the previous version, which was due to the fact that
> users might have expected that the markers would be set for newly loaded
> modules. Since there is no dependency between the marker and modules, the order
> could easily be wrong.
> 
> A hash table using a hash of the marker name is used to give O(1) lookup at
> module load time.
> 
> This serie of patches depends on the conditional calls. Please add at the end of
> the 2.6.22-mm1 series:
> 
> use-extra_rwdata-in-architectures.patch
> #
> linux-kernel-markers-architecture-independent-code.patch
> linux-kernel-markers-hash-table.patch
> linux-kernel-markers-kconfig-menus.patch
> linux-kernel-markers-documentation.patch
> linux-kernel-markers-port-blktrace-to-markers.patch
> 
> Mathieu
> 
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
