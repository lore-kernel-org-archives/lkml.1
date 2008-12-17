Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754968AbYLQMuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYLQMuA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYLQMtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:49:49 -0500
Received: from smtp.movial.fi ([62.236.91.34]:44350 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbYLQMts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:49:48 -0500
Message-ID: <4948F56A.7020501@movial.fi>
Date: Wed, 17 Dec 2008 14:49:46 +0200
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Organization: Movial Creative Technologies
User-Agent: Icedove 1.5.0.14eol (X11/20080724)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: Julia Lawall <julia@diku.dk>, khali@linux-fr.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 4/28] drivers/ide: Drop return value from	platform_driver
 remove functions
References: <Pine.LNX.4.64.0812101727230.21998@ask.diku.dk> <20081216195734.GA8032@fluff.org.uk>
In-Reply-To: <20081216195734.GA8032@fluff.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks wrote:
> On Wed, Dec 10, 2008 at 05:27:56PM +0100, Julia Lawall wrote:
>> From: Julia Lawall <julia@diku.dk>
>>
>> The return value of the remove function of a driver structure, and thus of
>> a platform_driver structure, is ultimately ignored, and is thus
>> unnecessary.  This patch removes the return value for the remove function
>> stored in a platform_driver structure.
>>
>> For the files drivers/i2c/busses/i2c-at91.c and
>> drivers/i2c/busses/i2c-mv64xxx.c, the original return value was the value
>> of a variable storing the result of calling i2c_del_adapter.  I have thus
>> also deleted the declaration and initialization of this variable.  For the
>> other files, the return values were always 0.
>>
>> A simplified version of the semantic patch that makes this change is as
>> follows: (http://www.emn.fr/x-info/coccinelle/)
> 
> I take it remove_new will eventually be renamed to remove once all
> the changes have been made?
> 
> Unless there are any objections I'll add this to the merge list for
> the next window.

Please be careful since the drivers/base/ part has not been applied yet, so I'm Cc:ing Greg now for his opinion.

Dmitri
