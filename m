Return-Path: <linux-kernel-owner+w=401wt.eu-S1761956AbZJNQIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761956AbZJNQIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761924AbZJNQIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:08:42 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49609 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761894AbZJNQIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:08:41 -0400
Date: Wed, 14 Oct 2009 11:07:48 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, randy.dunlap@oracle.com, arnd@arndb.de,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, kosaki.motohiro@jp.fujitsu.com,
       mingo@elte.hu, Pavel Emelyanov <xemul@openvz.org>,
       torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>,
       roland@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Message-ID: <20091014160748.GA13381@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <4AD511F1.7010207@zytor.com> <20091014013936.GC27627@count0.beaverton.ibm.com> <4AD5365E.5090709@zytor.com> <20091014044035.GB32114@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014044035.GB32114@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sukadev Bhattiprolu (sukadev@linux.vnet.ibm.com):
> H. Peter Anvin [hpa@zytor.com] wrote:
> | > 
> | > Except we can't use clone2() because it conflicts on ia64.  Care to propose
> | > a name you would prefer?
> 
> Yes, I am running out of ideas :-)
> 
> How about clone64_with_pids() ? - hope we don't need a 65th clone-flag :p

Well, maybe accept that adding more flags will still require a new syscall,
and call this clone_with_pids(), and only take a single 32-bit flags field?

Or, go back to clone_extended().

-serge
