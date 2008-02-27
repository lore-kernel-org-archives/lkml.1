Return-Path: <linux-kernel-owner+w=401wt.eu-S1760634AbYB0VGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbYB0VGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYB0VGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:06:32 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:51559 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbYB0VGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:06:31 -0500
Message-ID: <47C5CFEF.8020402@student.ltu.se>
Date: Wed, 27 Feb 2008 22:02:39 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Benny Halevy <bhalevy@panasas.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, khc@pm.waw.pl,
       bhalevy.lists@gmail.com, jengelh@computergmbh.de,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] CodeStyle: Use spaces when aligning/decorating
References: <1204062430.47c488def40a4@portal.student.luth.se> <20080226135444.f83a0536.randy.dunlap@oracle.com> <47C48FD8.5040205@student.ltu.se> <47C4AB5D.3000900@panasas.com>
In-Reply-To: <47C4AB5D.3000900@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benny Halevy wrote:
>
> How about this:
>
> -Tabs are 8 characters, and thus indentations are also 8 characters.
> -There are heretic movements that try to make indentations 4 (or even 2!)
> -characters deep, and that is akin to trying to define the value of PI to
> -be 3.
> +Tabs are used for logical indentation, e.g., code is indented with
> +a number of tabs equal to its nesting level.  From there on,
> +use space characters for decorative indentation.  This method
> +is agnostic to the editor's tab-expansion settings.
> +That said, expanding tabs to a small number of spaces (4, or even 2!) encourages
> +excessive nesting and resulting over-complexity; that is akin to trying to define
> +the value of PI to be 3.  Therefore, tabs are always assumed to be 8 characters-wide.
>
>   
Not sure about the PI-reference in that context, but the rest IMO looks 
good.

