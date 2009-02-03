Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZBCLsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZBCLsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZBCLsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:48:07 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:41923 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbZBCLsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:48:06 -0500
Date: Tue, 3 Feb 2009 12:49:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Victoria Muntean <vikimun@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [kernel make system] adding pre-check scripts
Message-ID: <20090203114951.GA14098@uranus.ravnborg.org>
References: <ab4346860902030028p5798d4afi8aec5c2fd5fc83e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab4346860902030028p5798d4afi8aec5c2fd5fc83e0@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 10:28:44AM +0200, Victoria Muntean wrote:
> Is there provision in kernel makefiles to execute user-supplied
> pre/post add-on scripts ? (by following some convention)
> 
> I have script pre-checks.sh, it checks that .config defines certain parameters
> certain way. This is to prevent [build with] accidental redefine of
> certain important parameters.
> 
> One possibility is to
>                ./my-pre-checks.sh && make
> But this is not perfect.
> It leaves of pre-checks optional easy to forget to run before build.
> Is it possible to make "make" execute my pre-script before build.

Hi Victoria.

We do not have such functionality and unless thre is a broad interest
I do not plan to add it either.
People usually include this in their 'kmake' scripts or whatever they name it.

	Sam
