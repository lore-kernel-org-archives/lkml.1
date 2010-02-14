Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab0BNKVN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 05:21:13 -0500
Received: from tossu.ebaana.net ([62.121.33.10]:3017 "EHLO tossu.ebaana.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758428Ab0BNKVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 05:21:12 -0500
X-Greylist: delayed 1466 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Feb 2010 05:21:11 EST
From: Lasse Collin <lasse.collin@tukaani.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [kernel.org users] XZ Migration discussion
Date: Sun, 14 Feb 2010 12:16:37 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.30-ARCH; KDE/4.3.1; i686; ; )
Cc: Jean Delvare <khali@linux-fr.org>, Pavel Machek <pavel@ucw.cz>,
       mirrors@kernel.org, "linux-kernel" <linux-kernel@vger.kernel.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org
References: <4B744E13.8040004@kernel.org> <20100213181008.479509f5@hyperion.delvare> <4B773B31.1020802@lougher.demon.co.uk>
In-Reply-To: <4B773B31.1020802@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002141216.37631.lasse.collin@tukaani.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-02-14 Phillip Lougher wrote:
> With xz you have just one C/C++ implementation with a single library
> with an undocumented API for C/C++ programmers.

I completely agree that language support is bad compared to the .gz 
format, but I think the above sentence makes it sound a bit too bad.

There are three C (no C++ needed) libraries that support the .xz format:
  - LZMA SDK (7-zip.org)
  - XZ Utils has liblzma (tukaani.org)
  - XZ Embedded (tukaani.org, limited support only)

The latter two are more or less based on LZMA SDK, although the code 
looks very different (different coding style, different APIs etc.).

The liblzma API has reference documentation as Doxygen tags in the API 
headers. They aren't the best docs and there's no tutorial or example 
programs yet, but the API certainly isn't undocumented. It has 
similarities to the zlib API, so those used to zlib shouldn't have 
trouble learning the basic features of liblzma, which are enough for 
most people.

There are liblzma bindings for Perl and Python, but I don't know how 
good they are.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
