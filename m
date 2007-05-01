Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbXEARG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbXEARG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbXEARG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:06:29 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:6935 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754870AbXEARG1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:06:27 -0400
Date: Tue, 1 May 2007 18:06:20 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl, hpa@zytor.com
Subject: Re: console font limits
Message-ID: <20070501170620.GA12118@deepthought>
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 12:09:46AM -0400, Albert Cahalan wrote:
> 
> BTW, the PSF font format documentation seems to suggest that
> there is a way to make the kernel handle combining accents:
> http://www.win.tue.nl/~aeb/linux/kbd/font-formats-1.html
> Does anybody know if that really works? I could sure use that.

 My reading of it suggests you need a precomposed version to which
the combining combination can be mapped (the 00c5 for Å in the
example).  Possibly, the fffe and ffff are used as delimiters for
the combination).  Maybe, it could be used for yoruba (yeah, I was
looking at that an hour before I read your mails) _if_ the font
has room to fit in a "private use" character which can hold the
precomposed value.

 For any letter where a precomposed version is in the unicode
standards, the only use for combining characters in a console font
seems to be as a way of displaying text where somebody has already
used them.

 For latin languages which need additional composed letters, the
bigger problem will probably be the input - I've no idea if the
console keymap can use combining keys (direct input of the unicode
hex is available, of course), and I can't manage to get the direct
input of the codes for combining diacriticals to work in combination
in my preferred graphical terminal.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
