Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbYIHAuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbYIHAuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 20:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbYIHAuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 20:50:04 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33771 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750823AbYIHAuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 20:50:03 -0400
X-Greylist: delayed 1281 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Sep 2008 20:50:03 EDT
Message-ID: <48C471AE.8060809@acm.org>
Date: Sun, 07 Sep 2008 18:28:30 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>,
       "Hamid R. Jahanjou" <hamid.jahanjou@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
References: <48BFCECE.90103@gmail.com>	<87iqtbuez9.fsf@basil.nowhere.org>	<48C19648.8030002@gmail.com>	<20080905194501.GZ18288@one.firstfloor.org> <20080906014214.22f28548@riellaptop.surriel.com>
In-Reply-To: <20080906014214.22f28548@riellaptop.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080907/1KcUcI-0004cl-KB-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
[cut]
> On the other hand, you do want to avoid evicting data 
> that the process is still using, just because you are 
> swapping out a not recently referenced page on a
> nearby virtual address.

How about writing the nearby pages to swap anyway and mark the still 
in-use pages as SwapCache.
