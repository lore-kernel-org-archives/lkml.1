Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbZIULM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbZIULM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZIULM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:12:27 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51009 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZIULM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:12:27 -0400
Subject: Re: [PATCH 2/4] send callback when swap slot is freed
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: ngupta@vflare.org, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp
In-Reply-To: <Pine.LNX.4.64.0909211149360.32504@sister.anvils>
References: <1253227412-24342-1-git-send-email-ngupta@vflare.org>
	 <1253227412-24342-3-git-send-email-ngupta@vflare.org>
	 <1253256805.4959.8.camel@penberg-laptop>
	 <Pine.LNX.4.64.0909180809290.2882@sister.anvils>
	 <1253260528.4959.13.camel@penberg-laptop>
	 <Pine.LNX.4.64.0909180857170.5404@sister.anvils>
	 <1253266391.4959.15.camel@penberg-laptop> <4AB3A16B.90009@vflare.org>
	 <4AB487FD.5060207@cs.helsinki.fi>
	 <Pine.LNX.4.64.0909211149360.32504@sister.anvils>
Date: Mon, 21 Sep 2009 14:12:30 +0300
Message-Id: <1253531550.5216.32.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Mon, 2009-09-21 at 12:07 +0100, Hugh Dickins wrote:
> Is the main basis for your disgust at the way that Nitin installs the
> callback, that loop down the swap_info_structs?  I should point out
> that it was I who imposed that on Nitin: before that he was passing a
> swap entry (or was it a swap type extracted from a swap entry?
> I forget), which was the sole reference to a swp_entry_t in his
> driver - I advised a bdev interface.

The callback setup from ->read() just looks gross. However, it's your
call Hugh so I'll just shut up now. ;-)

			Pekka

