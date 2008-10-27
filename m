Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYJ0VMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYJ0VMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYJ0VMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:12:42 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:28645 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbYJ0VMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:12:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=lZ2Xrv/g3poofC1612VWhJobfmMQV05azmO+5kz4ah1CPGA9jIYgKbHpHu34BmOLdr
         VILBTWW85QC6Mel9rU+v8OkdhslJg6pjbpq/LvL7yb9H6ViEPE1fucUm96OLMOul6ECT
         dCf6RzTUhucjzmte/7XZLvgpxD4oZlYZ25tHU=
Message-ID: <49062EC0.4040809@gmail.com>
Date: Mon, 27 Oct 2008 14:12:32 -0700
From: Rob MacKinnon <c4blem0nkey@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080904)
MIME-Version: 1.0
To: Andreas Gruenbacher <agruen@suse.de>
CC: Stephen Smalley <sds@tycho.nsa.gov>, rob.mackinnon@gmail.com,
       hpa@zytor.com, hugh@veritas.com, linux-kernel@vger.kernel.org,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: tmpfs support of xattrs?
References: <4902DD98.4090302@gmail.com> <4906211E.8030603@gmail.com> <1225139131.31818.51.camel@moss-spartans.epoch.ncsc.mil> <200810272153.56301.agruen@suse.de>
In-Reply-To: <200810272153.56301.agruen@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Gruenbacher wrote:
> On Monday, 27 October 2008 21:25:31 Stephen Smalley wrote:
>> Looks like a bug in Smack's implementation of the inode_listsecurity
>> hook to me.  Did you mean to enable Smack in your kernel config?
> 
> Yes, there is at least one bug there; this kernel is broken. You may want to 
> try booting with a kernel command line option like "security=none", which 
> *should* turn smack off.
> 
> Andreas

All,

Indeed the kernel cmdline option security=none did disable smack. So
atleast that works. Thank you all for helping me track this down.  I can
now return to updating packages (some of which have been waiting
patiently for this to be cleared up)!  Though I will be looking forward
to this feature working as it was intended. ;)  Let me know if there is
a bug # assigned and I'll quietly return to lurking... ;)

-- Rob
