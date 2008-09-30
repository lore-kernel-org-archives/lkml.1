Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbYI3AN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbYI3AN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 20:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYI3ANv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 20:13:51 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:56399 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbYI3ANu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 20:13:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DK4P9kYKBExiGgfwF5S9tEW8cbijb2deZ9vnx5f50QLPQj0xAGclgbCFQdA3fGAZ0p
         BPyisx1tVlaqB0hqB6gWYJFducY9uPC8D8/1sSBXd0i3yucjf56AD1xCJKQLZwBkienP
         kxldNxDMA9XkgQ6T9SNBsW5KqD+nG9oY5CDZs=
Message-ID: <9e4733910809291713r5016c3a2if609bb45ed4763c2@mail.gmail.com>
Date: Mon, 29 Sep 2008 20:13:49 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Subject: Re: [RFC PATCH 0/4] Implementation of IR support using the input subsystem
Cc: emmanuel.fuste@laposte.net, linux-kernel@vger.kernel.org
In-Reply-To: <48E1621D.1080803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48E15447.1000200@laposte.net>
	 <9e4733910809291602v2d2611edqba3663f7d2711ea9@mail.gmail.com>
	 <48E1621D.1080803@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 7:17 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> Suppose I have non-standard remote, and I want to teach lirc to use it,
> and I have general purpose receiver, how can I do this?

You need to write an app to use the sysfs interface for raw code. Or
you could write an in-kernel encoder/decoder and use the standard
interfaces. Or you could throw it away and spend $10 for a standard
one.


-- 
Jon Smirl
jonsmirl@gmail.com
