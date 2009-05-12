Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbZELN7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbZELN7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZELN7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:59:39 -0400
Received: from welcomes-you.com ([85.214.50.128]:49693 "EHLO
	smtp.welcomes-you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbZELN7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:59:38 -0400
Message-ID: <4A0980C6.2080204@aei.mpg.de>
Date: Tue, 12 May 2009 15:59:34 +0200
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: sky2 problem with WARNING: at net/sched/sch_generic.c:219
References: <4A0924FF.7040502@aei.mpg.de>
In-Reply-To: <4A0924FF.7040502@aei.mpg.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Carsten Aulbert schrieb:

> Anyone an idea what this is about?

Further testing and debugging revealed that it's probably related to
wrong autosensing. It should be rx/tx:off but rx is set to on. So far no
idea why this happens (and why the device goes "offline" for some time).
Anyone with an idea?

Cheers

Carsten


