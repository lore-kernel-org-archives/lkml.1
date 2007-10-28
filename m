Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbXJ1NvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbXJ1NvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 09:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbXJ1Nu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 09:50:57 -0400
Received: from isilmar.linta.de ([213.239.214.66]:40652 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751752AbXJ1Nu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 09:50:56 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Oct 2007 09:50:56 EDT
Date: Sun, 28 Oct 2007 14:44:14 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Olof Johansson <olof@lixom.net>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v3] pcmcia: Convert io_req_t to use unsigned int
Message-ID: <20071028134414.GF26943@isilmar.linta.de>
Mail-Followup-To: Olof Johansson <olof@lixom.net>,
	Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070905142742.GA1760@lixom.net> <20070914034854.1658a9cf.akpm@linux-foundation.org> <20070921221516.GA7926@lixom.net> <20070921233936.2aeb2504@the-village.bc.nu> <20070922062551.GE10625@parisc-linux.org> <20070922091303.GA12525@lst.de> <20071019201720.GA13234@lixom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019201720.GA13234@lixom.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 03:17:20PM -0500, Olof Johansson wrote:
> Convert the io_req_t members to unsigned int, to allow use on machines
> with more than 16 bits worth of IO ports (i.e. secondary busses on
> ppc64, etc).

Agreed, though I'd prefer if we got rid of kio_addr_t at the same time, and
convert its users to unsigned int as well -- as was pointed out earlier in
this thread, there's no known usage of IO ports larger than 32 bits.

	Dominik
