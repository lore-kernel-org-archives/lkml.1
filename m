Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbZIJQZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbZIJQZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 12:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZIJQZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 12:25:02 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:56776 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZIJQZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 12:25:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=PMDmZWzTa/dmikK8/qPjID6nDfquxlNbtJUQ0LAeVkRLnmjCI6PZm7f18AEwINRVl7
         J3S+FYhiQMcZn0/mZ97Eu0MUb2yHA2hqItNrDyRAE3lyXtdSKfaM4dqakxwBco5GLdpI
         X6wfq7PiIh2m3i5+1BYUe/d/07+sLy1VRS5ok=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Subject: Re: 2.6.31-rc6 (yeah, I know...): weird tty / X.org state currently
Date: Thu, 10 Sep 2009 09:25:00 -0700
User-Agent: KMail/1.12.0 (Linux/2.6.31; KDE/4.3.0; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090910103126.GA17742@rhlx01.hs-esslingen.de>
In-Reply-To: <20090910103126.GA17742@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <20090910165837.50544526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 September 2009 03:31:26 am Andreas Mohr wrote:
> Possibly the kernel's control key state got stuck in a weird state,
> perhaps due to some input layer race conditions or so.
>
> Or is it X.org's input handling which is responsible for Ctrl-Alt-F1
> etc. combos? I wouldn't think so...

X is solely responsible for handling input when active. It switches
console in RAW mode which bypasses kernel processing) and does it's
own thing. This includes switching VTs upon Ctrl-ALt-Fx.

-- 
Dmitry
