Return-Path: <linux-kernel-owner+w=401wt.eu-S933307AbYFFXXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307AbYFFXXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 19:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757616AbYFFXWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 19:22:49 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:37403 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017AbYFFXWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 19:22:49 -0400
X-Greylist: delayed 949 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jun 2008 19:22:48 EDT
Date: Fri, 6 Jun 2008 18:06:38 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Paul Mackerras <paulus@samba.org>
Cc: tklein@de.ibm.com, Jeff Garzik <jeff@garzik.org>, themann@de.ibm.com,
       Hannes Hering <hannes.hering@linux.vnet.ibm.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       ossrosch@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org, raisch@de.ibm.com,
       Badari Pulavarty <pbadari@us.ibm.com>, ossthema@de.ibm.com
Subject: Re: [PATCH 1/2] make walk_memory_resource available with
 MEMORY_HOTPLUG=n
Message-ID: <20080606230638.GC6638@localdomain>
References: <200805071443.20192.hannes.hering@linux.vnet.ibm.com>
 <20080528164405.GA4836@localdomain>
 <200806031007.40162.hannes.hering@linux.vnet.ibm.com>
 <20080603204908.GB7475@localdomain> <1212527335.23656.2.camel@badari-desktop>
 <4845B382.20205@garzik.org> <20080603223054.GC7475@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603223054.GC7475@localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: 438B3A30-341D-11DD-8895-B8BFEAD4C077-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Lynch wrote:
> The ehea driver was recently changed[1] to use walk_memory_resource() to
> detect the system's memory layout.  However, walk_memory_resource() is
> available only when memory hotplug is enabled.  So CONFIG_EHEA was
> made to depend on MEMORY_HOTPLUG [2], but it is inappropriate for a
> network driver to have such a dependency.
> 
> Make the declaration of walk_memory_resource() and its powerpc
> implementation (ehea is powerpc-specific) unconditionally available.

Paul, can you take these two patches, or should I send them to akpm?
