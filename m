Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbZBFJdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbZBFJdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbZBFJc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:32:58 -0500
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:59707 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757308AbZBFJcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:32:48 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-16.arcor-online.net 42BEC2577B4
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Mapping non-page aligned data to user
To: Vira <sri1369_s@yahoo.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Fri, 06 Feb 2009 10:32:41 +0100
References: <c2mBW-7mZ-15@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LVN4j-0001Iz-OD@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vira <sri1369_s@yahoo.com> wrote:

> Is there a way to map a non-page aligned kernel physical address to user
> virtual address? remap_pfn_range and vm_insert_page operate only on
> page-aligned physical addresses.
> 
> If there is no such support, would it be too complicated to try out
> writing something on my own to map non-page aligned addresses (the data
> size is under my control - so I can make that a multiple of page size)?
> 
> Any suggestions appreciated.

It can only be done using segmented memory, and you don't want that.

