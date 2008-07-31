Return-Path: <linux-kernel-owner+w=401wt.eu-S1759104AbYGaVvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104AbYGaVvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbYGaVuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:50:52 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:47719 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414AbYGaVuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:50:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=ab4CBKViQQxUYuaD8jve3PmkLpgd93cuQrXlZEJ/37v92BKlwztS+dLY1yiTLNnJiuy64IotUqbIYIA3X6RLQktf8PuUB7TzPSYVmVB7DVuRgn8A129M7l1uzWGUDrd9;
Message-ID: <489233B7.7050401@simon.arlott.org.uk>
Date: Thu, 31 Jul 2008 22:50:47 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Tollef Fog Heen <tfheen@err.no>
CC: linux-kernel@vger.kernel.org, frank@kingswood-consulting.co.uk,
       werner@cornelius-consult.de
Subject: Re: [PATCH] Winchiphead CH340/1: support modem control and status
 lines, more baudrates
References: <8763qywfnn.fsf@xoog.err.no>
In-Reply-To: <8763qywfnn.fsf@xoog.err.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/08 08:18, Tollef Fog Heen wrote:
> Patch against current git as of last night (so 2.6.26).
> 
> * Add support for all baudrates, not just a hard coded set.
> * Make it possible to control modem control and status lines.
> 
> Signed-off-by: Tollef Fog Heen <tfheen@err.no>
> 
> ---
> 
> This is a cleanup of Werner Conelius' patch in
> http://kerneltrap.org/mailarchive/linux-kernel/2007/9/21/265323 which
> should be more acceptable to mainline.  Feel free to put him as author
> rather than me.

The correct format should be:

	From: Werner Cornelius <Werner.Cornelius@cornelius-consult.de>
	
	<description>
	
	Signed-off-by: Werner Cornelius <Werner.Cornelius@cornelius-consult.de>
	Signed-off-by: Tollef Fog Heen <tfheen@err.no>

However, this patch no longer applies to current git because of usb 
serial changes to include a 'tty' function parameter.

-- 
Simon Arlott
