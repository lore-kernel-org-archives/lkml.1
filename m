Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbXC1DIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbXC1DIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 23:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbXC1DIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 23:08:36 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:38483 "EHLO
	asav18.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbXC1DIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 23:08:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAO94CUZKhRO4UGdsb2JhbACHQIg2AQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: johann deneux <johann.deneux@gmail.com>
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom driver]
Date: Tue, 27 Mar 2007 23:08:33 -0400
User-Agent: KMail/1.9.3
Cc: Jiri Slaby <jirislaby@gmail.com>,
       "\"STenyaK (Bruno =?iso-8859-1?q?Gonz=E1lez?=)\"" <stenyak@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
References: <2460126662758025813@fi.muni.cz> <460983D6.7070409@gmail.com> <38b3b7c0703271434u2fddc4d1jc2b9af097e9c95b2@mail.gmail.com>
In-Reply-To: <38b3b7c0703271434u2fddc4d1jc2b9af097e9c95b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703272308.34441.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 March 2007 17:34, johann deneux wrote:
> What about adding a member to ff_effect which would be the number of the motor?
> We can't change the layout of ff_effect too much though, so we have to
> find unused bits and put them to work.
> 
> For instance, we could replace
> 
> __u16 type;
> 
> by
> 
> __u8 motor;
> __u8 type;
> 

Splitting type field seems to be a good idea.

-- 
Dmitry
