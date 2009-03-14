Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbZCNTUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbZCNTUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 15:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbZCNTUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 15:20:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:65100 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbZCNTUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 15:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=UJTKzwEZd+ERhyCrxMaPIQ/JxZZXJ1q/J7C/UeqZva2LUW1b+/8PFITwDQN9moccxf
         LLWVfI0CMx9C+I3gC84EX6K6EbdGI3bHIZksdVcxrmK6lk1H78bRpqq813wBt5RNi/8I
         UHtgVXxl62BYNSJ689pyzMTr0eWgtm8WKlZjg=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20090313175848.GB27891@fieldses.org>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com>
	 <20090311232356.GP13540@fieldses.org>
	 <20090312161047.GA15209@us.ibm.com>
	 <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com>
	 <20090313175848.GB27891@fieldses.org>
Date: Sun, 15 Mar 2009 08:20:17 +1300
Message-ID: <cfd18e0f0903141220u66230ceer22ef0cc6aed1d046@mail.gmail.com>
Subject: Re: VFS, NFS security bug? Should CAP_MKNOD and CAP_LINUX_IMMUTABLE 
	be added to CAP_FS_MASK?
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Igor Zhbanov <izh1979@gmail.com>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, neilb@suse.de,
       Trond.Myklebust@netapp.com, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 6:58 AM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Fri, Mar 13, 2009 at 09:21:23AM +1300, Michael Kerrisk wrote:
>> On Fri, Mar 13, 2009 at 5:10 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
>> > Quoting J. Bruce Fields (bfields@fieldses.org):
>> >> On Wed, Mar 11, 2009 at 03:53:34PM +0300, Igor Zhbanov wrote:
>> >> > Hello!
>> >> >
>> >> > It seems that CAP_MKNOD and CAP_LINUX_IMMUTABLE were forgotten to be
>> >> > added to CAP_FS_MASK_B0 in linux-2.6.x and to CAP_FS_MASK in
>> >> > linux-2.4.x. Both capabilities affects file system and can be
>> >> > considered file system capabilities.
>> >>
>> >> Sounds right to me--I'd expect rootsquash to guarantee that new device
>> >> nodes can't be created from the network.  Cc'ing random people from the
>> >> git log for include/linux/capability.h in hopes they can help.
>> >
>> > Yeah it seems reasonable.  If it is, then does that mean that we
>> > also need CAP_SYS_ADMIN (to write selinux labels) and CAP_SETFCAP
>> > (to set file capabilities) as well?
>>
>> If a change is made to CAP_FS_MASK, please do remember to CC
>> mtk.manpages@gmail.com, and linux-api@.
>
> OK, that's because the exact set of capabilities that is dropped on
> setfsuid is documented in capabilities(7)?  (Anywhere else?)

Not that I know of.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
