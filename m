Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbXKVQtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbXKVQtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 11:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbXKVQtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 11:49:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbXKVQtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 11:49:41 -0500
Date: Thu, 22 Nov 2007 17:49:36 +0100
From: Michal Schmidt <mschmidt@redhat.com>
To: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Cc: "Oliver Neukum" <oliver@neukum.org>, linux-kernel@vger.kernel.org
Subject: Re: Use of mutex in interrupt context flawed/impossible, need
 advice.
Message-ID: <20071122174936.75c8e65c@brian.englab.brq.redhat.com>
In-Reply-To: <c384c5ea0711220819j2fa19430sb54139191d181c3b@mail.gmail.com>
References: <c384c5ea0711220802i21e3df45q1d328aea63e7ebf4@mail.gmail.com>
	<200711221711.39134.oliver@neukum.org>
	<c384c5ea0711220819j2fa19430sb54139191d181c3b@mail.gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007 17:19:44 +0100
"Leon Woestenberg" <leon.woestenberg@gmail.com> wrote:

> I forgot to mention that I would like to be prepared for, and use the
> -rt patch soon. I understand (maybe wrongly?) that semaphores are not
> real-time pre-emptible, mutexes and spinlocks are.

Semaphores are preemptible, but they don't do priority inheritance.

Michal
