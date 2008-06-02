Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYFBRyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYFBRyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYFBRyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:54:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:55784 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751526AbYFBRyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:54:14 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/0B3Qmc7H0G5g204l4iEthMHPcc64tfSu1FWQY6+
	aKWBgRBbOVj6/I
Date: Mon, 2 Jun 2008 19:54:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: David Brownell <david-b@pacbell.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] generic GPIO parameter API
In-Reply-To: <Pine.LNX.4.64.0806021841500.30390@axis700.grange>
Message-ID: <Pine.LNX.4.64.0806021949210.30390@axis700.grange>
References: <Pine.LNX.4.64.0806021841500.30390@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008, Guennadi Liakhovetski wrote:

> struct gpio_parameter {
> 	char *name;
> 	void *arg;
> 	int (*get)(struct gpio_chip *chip, void *arg, unsigned offset, 
> 			int value);
> 	int (*set)(struct gpio_chip *chip, void *arg, unsigned offset, 
> 			int value);
> };

The (*get) should have "int *value" of course

> int gpio_register_parameter(struct gpio_chip *chip, struct gpio_parameter 
> 				*param);
> struct gpio_parameter *gpio_find_parameter(struct gpio_chip *chip, char 
> 						*name);

Actually, I think, it would be even better to just add two fields

	struct gpio_parameter	*param;
	int			param_n;

to struct gpio_chip.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
