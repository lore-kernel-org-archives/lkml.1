Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbYDKEtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbYDKEtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 00:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYDKEte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 00:49:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38505 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYDKEtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 00:49:33 -0400
Message-ID: <47FEEDD0.4000505@zytor.com>
Date: Thu, 10 Apr 2008 21:49:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Shakul Mohideen Hameed <smohideen@blackhole.labs.rootshell.ws>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT] git-clone failure over http
References: <c42f92750804092213p7b2c5607sa48a83086d45a825@mail.gmail.com>
In-Reply-To: <c42f92750804092213p7b2c5607sa48a83086d45a825@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shakul Mohideen Hameed wrote:
> I am getting errors while cloning few of the kernel sources over HTTP.
> Both proxy/direct modes are failing.
> Please advise.
>     - smohideen
> 

This happens when the repository maintainer hasn't done:

	chmod +x <repo>.git/hooks/post-update

This has to be done manually for some reason.

	-hpa

