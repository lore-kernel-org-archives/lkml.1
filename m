Return-Path: <linux-kernel-owner+w=401wt.eu-S1761990AbZJJQku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761990AbZJJQku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 12:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761823AbZJJQkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 12:40:49 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:48348 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbZJJQks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 12:40:48 -0400
Subject: ERESTARTSYS escaping from sem_wait with Preempt-RT
From: Blaise Gassend <blaise@willowgarage.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1255165747.6385.117.camel@doodleydee>
References: <1255165747.6385.117.camel@doodleydee>
Content-Type: text/plain
Organization: Willow Garage
Date: Sat, 10 Oct 2009 09:40:09 -0700
Message-Id: <1255192809.6385.120.camel@doodleydee>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies, the message below is for Preempt-RT, not RTLinux. The
original message with full details can be found here:
http://lkml.org/lkml/2009/10/10/36

On Sat, 2009-10-10 at 02:09 -0700, Blaise Gassend wrote:
> The attached python program, in which 500 threads spin with microsecond
> sleeps, crashes with a "sem_wait: Unknown error 512" (conditions
> described below). This appears to be due to an ERESTARTSYS generated
> from futex_wait escaping to user space (libc). My understanding is that
> this should never happen and I am trying to track down what is going on.


