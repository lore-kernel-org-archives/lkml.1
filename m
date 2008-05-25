Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYEYOTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYEYOTO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 10:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbYEYOS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 10:18:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35295 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYEYOS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 10:18:58 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: David Woodhouse <dwmw2@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>, Michael Buesch <mb@bu3sch.de>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
In-Reply-To: <1211724803.17151.36.camel@johannes.berg>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <1211707837.17151.14.camel@johannes.berg>
	 <95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org>
	 <200805251405.05684.mb@bu3sch.de>
	 <09817CD9-2158-4EC3-8AB4-17BBAF34A8DA@holtmann.org>
	 <1211724803.17151.36.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 25 May 2008 15:18:48 +0100
Message-Id: <1211725128.31212.108.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-25 at 16:13 +0200, Johannes Berg wrote:
> If Michael wants to serve his firmware blobs from an SQL database,
> he'd use a simple table like this:
> 
> CREATE TABLE firmware (
>         ID INTEGER,
>         name VARCHAR(100),
>         data BLOB
> );

That's fairly much what the in-kernel firmware support does (just
serving firmware from a flat table using the string as a key, that is.
If I tried using SQL in-kernel you should take me out back and shoot me,
of course).

-- 
dwmw2

