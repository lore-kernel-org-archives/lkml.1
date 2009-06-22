Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbZFVNL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbZFVNL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbZFVNLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:11:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41464 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754654AbZFVNLE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:11:04 -0400
References: <1245403695-20537-1-git-send-email-21cnbao@gmail.com> <20090619104738.GF5270@sirena.org.uk> <3c17e3570906212008n6071e987sbcd4b9377364ae78@mail.gmail.com> <20090622105727.GA29144@opensource.wolfsonmicro.com> <3c17e3570906220600l3471b6f0rc29c674b4a5ec2df@mail.gmail.com> (sfid-20090622_140014_795285_5B7D4C81)
Message-Id: <6485128A-22F2-48DA-824A-7B39B6EAD713@opensource.wolfsonmicro.com>
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: =?utf-8?B?5a6L5a6d5Y2O?= <21cnbao@gmail.com>
In-Reply-To: <3c17e3570906220600l3471b6f0rc29c674b4a5ec2df@mail.gmail.com> (sfid-20090622_140014_795285_5B7D4C81)
Content-Type: text/plain;
	charset=utf-8;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 8BIT
X-Mailer: iPhone Mail (7A341)
Mime-Version: 1.0 (iPhone Mail 7A341)
Subject: Re: [PATCH] New ASoC Drivers for ADI AD1938 codec
Date: Mon, 22 Jun 2009 14:11:03 +0100
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier.adi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 Jun 2009, at 14:00, 宋宝华 <21cnbao@gmail.com> wrote:

> So, does it mean I need to support both single and pair since we  
> don't know how users will use it? If I only create 4 pairs, how  
> could users control channels not in any pair?

You only need to do stereo, like I said users can still control the  
individual channels. Creating stereo controls only adds new ways of  
controlling things, it doesn't remove any capabilities.

>
