Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbXFNRei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbXFNRei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbXFNRea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:34:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43699 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbXFNRe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:34:29 -0400
Date: Thu, 14 Jun 2007 18:34:23 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [TOMOYO 5/9] Memory and pathname management functions.
Message-ID: <20070614173423.GB14771@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
References: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com> <4670EFE9.8090902@nttdata.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4670EFE9.8090902@nttdata.co.jp>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 04:36:09PM +0900, Kentaro Takeda wrote:
> We limit the maximum length of any string data (such as domainname and 
> pathnames)
> to TOMOYO_MAX_PATHNAME_LEN (which is 4000) bytes to fit within a single 
> page.
> 
> Userland programs can obtain the amount of RAM currently used by TOMOYO 
> from /proc interface.


Same NACK for this as for AppArmor, on exactly the same grounds.  Please
stop wasting your time on pathname-based non-solutions.

