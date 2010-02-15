Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab0BOVwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:52:37 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:38489 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab0BOVwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:52:35 -0500
From: James Cloos <cloos@jhcloos.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Jean Delvare <khali@linux-fr.org>, lasse.collin@tukaani.org,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [kernel.org users] XZ Migration discussion
In-Reply-To: <20100214094940.GB17999@1wt.eu> (Willy Tarreau's message of "Sun,
	14 Feb 2010 10:49:40 +0100")
References: <4B744E13.8040004@kernel.org> <20100211205129.GA26105@elf.ucw.cz>
	<20100213181008.479509f5@hyperion.delvare>
	<4B773B31.1020802@lougher.demon.co.uk>
	<20100214102308.1d1d6fff@hyperion.delvare>
	<20100214094940.GB17999@1wt.eu>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Mon, 15 Feb 2010 16:31:59 -0500
Message-ID: <m3wrye9od4.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:30:100215:w@1wt.eu::fGOh8mMUQOOq3pLP:00000000jcGIb
X-Hashcash: 1:30:100215:khali@linux-fr.org::r86iHYtmcYo1djzZ:0000000000000000000000000000000000000000001NGiI
X-Hashcash: 1:30:100215:lasse.collin@tukaani.org::unT3807oLjJ5WTDs:000000000000000000000000000000000000fDO5x
X-Hashcash: 1:30:100215:phillip@lougher.demon.co.uk::trlu7rcUWZaMwZhg:000000000000000000000000000000000nlfQj
X-Hashcash: 1:30:100215:linux-kernel@vger.kernel.org::YgOZU8k+fgS4ZEAK:00000000000000000000000000000000lHcAr
X-Hashcash: 1:30:100215:mirrors@kernel.org::OjNBfEYthbpC7Rdb:000000000000000000000000000000000000000000qqQ9F
X-Hashcash: 1:30:100215:users@kernel.org::tJAEiO7OeXfKC8ZA:2Komf
X-Hashcash: 1:30:100215:ftpadmin@kernel.org::dF/Yc+fayX6xe4oJ:00000000000000000000000000000000000000000YkhO6
X-Hashcash: 1:30:100215:pavel@ucw.cz::GWNDogVDsSldNkAs:0000YvC7Y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "W" == Willy Tarreau <w@1wt.eu> writes:

W> Well, I personally like to be able to simply run "less patch-2.6.27.45.gz"
W> and have it transparently uncompressed and dumped on my terminal. It
W> doesn't do that on bz2. We could find multiple examples.

It does here, and lzma & xz, too.  And has since just days after Lasse
annouced that the new name would be xz.

Your LESSOPEN controls that, and can be easily coded to support any archive.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
