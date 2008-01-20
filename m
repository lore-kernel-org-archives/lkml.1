Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbYATFXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbYATFXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 00:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYATFXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 00:23:21 -0500
Received: from mail.davidb.org ([66.93.32.219]:59820 "EHLO mail.davidb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbYATFXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 00:23:20 -0500
X-Greylist: delayed 1803 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jan 2008 00:23:20 EST
Date: Sat, 19 Jan 2008 20:53:12 -0800
From: David Brown <lkml@davidb.org>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Update emacs indentation instructions.
Message-ID: <20080120045312.GA9029@old.davidb.org>
References: <1200783192-24399-1-git-send-email-lkml@davidb.org> <87fxwt5l6a.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87fxwt5l6a.fsf@saeurebad.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2008 at 02:40:29AM +0100, Johannes Weiner wrote:

>> +(setq c-default-style "linux")
>
>This variable is not defined when emacs starts up.  Best is to always
>use a hook.

Both of these examples are directly copied out of the emacs manual.

Setting a variable before a module is loaded will override the default set
in the module.  No need to use a hook for something simple like this.

c-default-style is defined with 'defcustom':

   Declare SYMBOL as a customizable variable that defaults to VALUE.
   DOC is the variable documentation.
   
   Neither SYMBOL nor VALUE need to be quoted.
   If SYMBOL is not already bound, initialize it to VALUE.

so the intent is to allow the user to override the value by setting it
before the module is loaded.

Dave
