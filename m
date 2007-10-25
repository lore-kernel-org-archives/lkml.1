Return-Path: <linux-kernel-owner+w=401wt.eu-S1760963AbXJYECV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963AbXJYECV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbXJYECM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:02:12 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:30873 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751415AbXJYECL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:02:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=pKjvNKWEou8T4MvB2L2Z8O+n13G6085cRyf5qfQHjIq9EQhhykO6M6IWFivIGqON0njUjN06nPsjvmQY1r2pAstz9wb2ItUS/9vCjYO/hON0MLIpjbkBjetFH9gg5BSPRqaaFlbNAwlXTLnWYLHzssENclzIIWh8cTVvgyx0Y0E=  ;
X-YMail-OSG: LUihNK4VM1kR8mN5Bm7i.P9NcUs0EZKR6__xxsJ7nbexc1nb
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/5] TASK_KILLABLE
Date: Thu, 25 Oct 2007 13:55:31 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <11927463623428-git-send-email-matthew@wil.cx>
In-Reply-To: <11927463623428-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710251355.31885.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2007 08:25, Matthew Wilcox wrote:
> This series of patches introduces the facility to deliver only fatal
> signals to tasks which are otherwise waiting uninterruptibly.


This is pretty nice I think. It also is a significant piece of
infrastructure required to fix some of the main oom kill deadlocks.
