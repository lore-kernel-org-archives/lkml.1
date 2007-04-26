Return-Path: <linux-kernel-owner+w=401wt.eu-S1751003AbXDZXqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003AbXDZXqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbXDZXqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:46:05 -0400
Received: from gw.goop.org ([64.81.55.164]:57814 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbXDZXqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:46:03 -0400
Message-ID: <463139DB.8070607@goop.org>
Date: Thu, 26 Apr 2007 16:46:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Phy Prabab <phyprabab@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Non continuous VM address space
References: <2fe399760704261333g4dbf79a1p92be761d3680c9d7@mail.gmail.com>
In-Reply-To: <2fe399760704261333g4dbf79a1p92be761d3680c9d7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phy Prabab wrote:
> Sometimes the next memory
> allocation is several megs above where the previous mapping came from.
> Is this possible?

The kernel is free to place mmaped memory whereever it likes unless you
use MAP_FIXED and specify an address.

    J
