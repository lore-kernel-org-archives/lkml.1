Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbXJVTRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbXJVTRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbXJVTRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:17:22 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:56689 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbXJVTRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:17:21 -0400
Message-ID: <471CF73D.5090909@tiscali.nl>
Date: Mon, 22 Oct 2007 21:17:17 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] unlock before bug returns
References: <471C0697.1040906@tiscali.nl> <471C11E5.2000003@tiscali.nl>	 <20071022001045.131ea465@bree.surriel.com>	 <471C930D.4000004@tiscali.nl> <84144f020710220540i7be08eednf40db8367669825f@mail.gmail.com> <471C9C70.8000206@keyaccess.nl>
In-Reply-To: <471C9C70.8000206@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 10/22/2007 02:40 PM, Pekka Enberg wrote:
> 
>> NAK. This will cause double-unlock when CONFIG_BUG is disabled. It's
>> incorrect to assume that BUG() will always terminate the current
>> process.
> 
> (which by the way also means that the "return;" delete from your
> original patch changes behaviour for !CONFIG_BUG, and probably not for
> the better).
> 
> Rene.

Thanks for your comments. A patch containing this suggestion is:

[PATCH retry] return hidden bug and unlock bugs.

Roel
