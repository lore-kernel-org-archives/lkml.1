Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbYJ2P40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbYJ2P40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbYJ2P4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:56:17 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:8422 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbYJ2P4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:56:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=InOHWe66Nc2aRzAZZh7xq8PYhszs6ieuyQ+4XJZF0RAwo30X2eBimkOSPKSELhlKHc
         m/VNKggEdCKVUQHlR3tU8RsA6qF4hp0K4J0JokgkriiHXFDNoJSimHK223cOX1YT2v1a
         Sdggq1PRDpcsIomN4+K8duAGQsnZJQR+t1G4w=
Message-ID: <49088797.3060802@gmail.com>
Date: Wed, 29 Oct 2008 08:56:07 -0700
From: Rob MacKinnon <c4blem0nkey@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080904)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: rob.mackinnon@gmail.com, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, hpa@zytor.com, hugh@veritas.com,
       linux-kernel@vger.kernel.org
Subject: Re: tmpfs support of xattrs?
References: <4902DD98.4090302@gmail.com> <4906211E.8030603@gmail.com> <1225139131.31818.51.camel@moss-spartans.epoch.ncsc.mil> <200810272153.56301.agruen@suse.de> <49062EC0.4040809@gmail.com> <4906A871.6010501@schaufler-ca.com>
In-Reply-To: <4906A871.6010501@schaufler-ca.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Casey Schaufler wrote:
> Rob MacKinnon wrote:
>> Andreas Gruenbacher wrote:
>>  
>>> On Monday, 27 October 2008 21:25:31 Stephen Smalley wrote:
>>>    
>>>> Looks like a bug in Smack's implementation of the inode_listsecurity
>>>> hook to me.  Did you mean to enable Smack in your kernel config?
>>>>       
>>> Yes, there is at least one bug there; this kernel is broken. You may
>>> want to try booting with a kernel command line option like
>>> "security=none", which *should* turn smack off.
>>>
>>> Andreas
>>>     
>>
>> All,
>>
>> Indeed the kernel cmdline option security=none did disable smack. So
>> atleast that works. Thank you all for helping me track this down.  I can
>> now return to updating packages (some of which have been waiting
>> patiently for this to be cleared up)!  Though I will be looking forward
>> to this feature working as it was intended. ;)  Let me know if there is
>> a bug # assigned and I'll quietly return to lurking... ;
> 
> It looks like a trivial fix and the patch is here. I have just started
> testing it myself, but if I don't send it now it will be Wednesday before
> I do. No sign-off because I haven't verified it, but I would be delighted
> if you would pass judgement on its efficacy. Thank you.
> 

All,

Applied, compiled, and tested clean on a P4 Prescott. I'll try this a
little later on my x64. Thank you for this fix, and thank you all for
just a fast response.

- -- Rob

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJJCIeXAAoJEPviweVbLO8VzcQP/i09jHZpF1yulLj7NsnyKtUB
F3Dni/2Qu8pUQ0qG/r4i99e78YS2be781E7qjKkSRxsp+zw90h9qENqHU0dCI7P5
d9FFZqmOp1eVxYPy2Qm7L8QgOrO852G0/No3uetgNj5WdSQVEEzIjJbQIp8pkYhd
Q/BLKbLW9DhwRHN4GlgMa6xsCxVgP1GFasnRb5scdoWmTswwfVbbC1PiGXYP7rrz
sfDGKgBHX7U3/QAZSw2ihm5t/N2DZYJas5JG1Ywyx6bp+Np51nzbrhaMmg04mp2r
HyWYvqxxK4Ukhw8wFqFL6qZxrAluBRjx++INXgmWqZydp8mW83zeRV1c/NInrOZf
s5wnk796579l3Wme3o5o1bxS1jLYQ5LMSI/5wjYT2W32g8wvj2er5Pj3utYvVG9B
5uKW3bqeUZKblQQBbbKoG4qPTZ6xHe21tDby2PcJj5KNevzXuPWGvVZg1jdYYVnN
DVTPmaHrtk3Z1MdlwJlRCIamAHXW0hwfDY7aYqaQAI2oTJSBFJanw1aGp5POUH+X
2RT7ychNDRvp22KSqA8DOqD5wucy8fgqQsuFu4R8CkW5Gdq3uST+F4ELbZxKRmqG
prNVUY72Di4ynnSFca6CFH3Cwh/jpYE32/ZD+56iOqUd/8LqgEYQxEarDh3B+sjF
X2JuRe4mmwHG+LtrjnOe
=lrma
-----END PGP SIGNATURE-----
