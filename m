Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZCLUVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZCLUVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 16:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZCLUV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 16:21:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:34760 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbZCLUVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 16:21:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=q80saEbBuOs82RMUHv72+aKR4MbPMtp3+my7D145ImgMbEt2V3L2LG4ZmWGnEmJv8P
         +XbmlDaI9O8sxs91Pb/84SzUHuHRANXvEo4VOZDjMLvsslIQoU2ny4Yu4wZ+6jMrZcuw
         AGxgcv1ZwOp3mNPGzAh6BxWNv+3xTYUPP8jeY=
MIME-Version: 1.0
In-Reply-To: <20090312161047.GA15209@us.ibm.com>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com>
	 <20090311232356.GP13540@fieldses.org>
	 <20090312161047.GA15209@us.ibm.com>
Date: Fri, 13 Mar 2009 09:21:23 +1300
X-Google-Sender-Auth: e2050b26c3016e9a
Message-ID: <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com>
Subject: Re: VFS, NFS security bug? Should CAP_MKNOD and CAP_LINUX_IMMUTABLE 
	be added to CAP_FS_MASK?
From: Michael Kerrisk <mtk.manpages@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Igor Zhbanov <izh1979@gmail.com>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, neilb@suse.de,
       Trond.Myklebust@netapp.com, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 5:10 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Quoting J. Bruce Fields (bfields@fieldses.org):
>> On Wed, Mar 11, 2009 at 03:53:34PM +0300, Igor Zhbanov wrote:
>> > Hello!
>> >
>> > It seems that CAP_MKNOD and CAP_LINUX_IMMUTABLE were forgotten to be
>> > added to CAP_FS_MASK_B0 in linux-2.6.x and to CAP_FS_MASK in
>> > linux-2.4.x. Both capabilities affects file system and can be
>> > considered file system capabilities.
>>
>> Sounds right to me--I'd expect rootsquash to guarantee that new device
>> nodes can't be created from the network.  Cc'ing random people from the
>> git log for include/linux/capability.h in hopes they can help.
>
> Yeah it seems reasonable.  If it is, then does that mean that we
> also need CAP_SYS_ADMIN (to write selinux labels) and CAP_SETFCAP
> (to set file capabilities) as well?

If a change is made to CAP_FS_MASK, please do remember to CC
mtk.manpages@gmail.com, and linux-api@.

Cheers,

Michael


-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/ Found a documentation bug?
http://www.kernel.org/doc/man-pages/reporting_bugs.html
