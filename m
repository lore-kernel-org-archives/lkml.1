Return-Path: <linux-kernel-owner+w=401wt.eu-S964875AbZKYOAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875AbZKYOAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934687AbZKYOAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:00:07 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46087 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934617AbZKYOAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:00:04 -0500
Date: Wed, 25 Nov 2009 08:00:09 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Add recursive directory matching operator
 support.
Message-ID: <20091125140009.GA602@us.ibm.com>
References: <200911242200.AFC90128.FFJtHLOFVMQSOO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911242200.AFC90128.FFJtHLOFVMQSOO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> TOMOYO 1.7.1 has recursive directory matching operator support.
> I want to add it to TOMOYO for Linux 2.6.33 .
> ----------
> [PATCH] TOMOYO: Add recursive directory matching operator support.
> 
> This patch introduces new operator /\{dir\}/ which matches
> '/' + 'One or more repetitions of dir/' (e.g. /dir/ /dir/dir/ /dir/dir/dir/ ).

As a unix admin, I expect something like

	/{bin,sbin}/init
(or more likely /{s,}bin/init )

to mean match both /bin/init and /sbin/init.  Are you sure you want to use
this syntax for 'in_repeating'?

-serge
