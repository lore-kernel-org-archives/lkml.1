Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZAaDmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZAaDmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZAaDmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:42:09 -0500
Received: from kroah.org ([198.145.64.141]:46287 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751612AbZAaDmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 22:42:08 -0500
Date: Fri, 30 Jan 2009 19:40:02 -0800
From: Greg KH <greg@kroah.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ferenc Wagner <wferi@niif.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc2 dies on startup
Message-ID: <20090131034002.GD2947@kroah.com>
References: <877i4rjw38.fsf@tac.ki.iif.hu> <20090125224625.96429d3d.akpm@linux-foundation.org> <d6200be20901261629y2e3d8804h16055b9497125371@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20901261629y2e3d8804h16055b9497125371@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 04:29:55PM -0800, Arve Hjønnevåg wrote:
> On Sun, Jan 25, 2009 at 10:46 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > At a guess I'd say that drivers/staging/android/ram_console.c is calling
> > the reed-solomon code earlier than it's expecting.  But that might be
> > totally wrong.
> 
> Yes, but it also is trying to use a zero sized buffer at virtual
> address 0 so it will not work much better if you turn off ecc.
> 
> This patch (to the android kernel tree) add some validation:

<snip>

Care to redo this for the current tree so that I can apply it?

thanks,

greg k-h
