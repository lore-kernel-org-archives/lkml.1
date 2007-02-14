Return-Path: <linux-kernel-owner+w=401wt.eu-S1751513AbXBNJfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbXBNJfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 04:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbXBNJfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 04:35:48 -0500
Received: from fed1rmmtao106.cox.net ([68.230.241.40]:36964 "EHLO
	fed1rmmtao106.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbXBNJfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 04:35:47 -0500
From: Junio C Hamano <junkio@cox.net>
To: Andy Parkins <andyparkins@gmail.com>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.0
References: <7vlkj1v3av.fsf@assigned-by-dhcp.cox.net>
	<200702140906.37440.andyparkins@gmail.com>
Date: Wed, 14 Feb 2007 01:35:46 -0800
In-Reply-To: <200702140906.37440.andyparkins@gmail.com> (Andy Parkins's
	message of "Wed, 14 Feb 2007 09:06:35 +0000")
Message-ID: <7vabzht72l.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Parkins <andyparkins@gmail.com> writes:

> On Wednesday 2007 February 14 03:14, Junio C Hamano wrote:
>
>>  - There is a configuration variable core.legacyheaders that
>
>> The above two are not enabled by default and you explicitly have
>> to ask for them, because these two features make repositories
>
> It isn't really the case that you have to _enable_ legacyheaders?  It defaults 
> to on already.  You actually have to disable legacyheaders.

Ah, true.  What it should have stressed is that we currently
default to the safer, backward compatible behaviour, and you have
to explicitly ask to use more efficient but incompatible
encoding by setting core.legacyheaders to false.


