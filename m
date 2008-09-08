Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYIHSpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYIHSpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbYIHSpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:45:08 -0400
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:25737 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752225AbYIHSpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:45:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kjq4gH9TpnNX3uTemtNxtnfG1VLY0w7oBc//JmmcvT294SMXKFUADw/5FxJOTEm6qoO5x0i9GkjqEI2tXtnzIMS0zQctGbbdkjDS6kX9QX19fGyLLhads/6i67vscUoF3nED0+LErCUv5wOm2Y6PCOle9LxXCFaLW5WLuFIuGQk=  ;
X-YMail-OSG: ASXJT7YVM1nbmuL8GgZGd73CPkLLkCxRHzXaiAs1EcckT8.R8BT3OcidEm8XS3yg_1NLFVKpSbQt0pNuAi0CQBq1pjqMhIT.vqH_MGWnULdAbdl4.a21u4RoDNSoKk8vj40-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 0 of 3] Low memory corruption detection and workaround
Date: Tue, 9 Sep 2008 04:44:49 +1000
User-Agent: KMail/1.9.5
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Hugh Dickens <hugh@veritas.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
References: <patchbomb.1220777491@localhost> <200809082123.04780.nickpiggin@yahoo.com.au> <48C5570B.7050109@goop.org>
In-Reply-To: <48C5570B.7050109@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809090444.50038.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 02:47, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > Why not high memory as well? We put page tables there too...
>
> Well, the specific problem is that the BIOS appears to corrupt low
> memory.  It might corrupt other memory anywhere, but that would be
> pretty pathologically evil.  The assumption is that it gets away with it
> because its memory that Windows doesn't otherwise use or something.

OK, fine, sorry I didn't follow the thread back.
