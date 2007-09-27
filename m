Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbXI0PVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbXI0PVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbXI0PVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:21:16 -0400
Received: from smtp19.orange.fr ([80.12.242.17]:1241 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbXI0PVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:21:15 -0400
X-ME-UUID: 20070927152113799.C30D61C000B5@mwinf1911.orange.fr
Subject: Re: Floating Point Issue
From: Xavier Bestel <xavier.bestel@free.fr>
To: mahamuni ashish <ash_lkp@yahoo.co.in>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <109515.18343.qm@web7805.mail.in.yahoo.com>
References: <109515.18343.qm@web7805.mail.in.yahoo.com>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 17:21:08 +0200
Message-Id: <1190906468.24478.107.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-27 at 12:41 +0100, mahamuni ashish wrote:
> int main()
> {
> float f= 1256.35;
> char ch[4];
> 
> printf("\n1. f : %f",f);
> memset(ch,'\0',strlen(ch) );

Can't work. ch[]'s content is undefined, so strlen(ch) may read anywhere
in memory, and/or memset() write anywhere.

	Xav


