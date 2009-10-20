Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899AbZJTFZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbZJTFZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 01:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbZJTFZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 01:25:44 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:34736 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbZJTFZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 01:25:43 -0400
Date: Tue, 20 Oct 2009 07:25:47 +0200
From: Andreas Mohr <andi@lisas.de>
To: Peter Feuerer <peter@piie.net>
Cc: Andreas Mohr <andi@lisas.de>, Borislav Petkov <petkovbb@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch] acerhdf: Return temperature in milidegree
Message-ID: <20091020052547.GA10289@rhlx01.hs-esslingen.de>
References: <20091019102116.222ff9c3.peter@piie.net> <20091019091617.GA13277@rhlx01.hs-esslingen.de> <cone.1255987487.209127.3188.1000@deskpiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1255987487.209127.3188.1000@deskpiie>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 19, 2009 at 11:24:47PM +0200, Peter Feuerer wrote:
> I agree with you in these points, but I have also some disadvantages to discuss:
>
> Disadvantages:
> - Thinking about the implemenation such a macro would require, users may  
>   get confused. They would still set the fanon / fanoff trip points in   
> degree, but when they read documentation or the current temperature,   
> millidegree is used.  - I think "TEMP_DEGREE_TO_SYS(59)" in code is not   
> as good readable as "59000"
>
> what about writing something like "59 * 1000" insead of "59000"?
>
> Or something like that:
>
> #define FACTOR_MILLIDEGREE 1000
> 59 * FACTOR_MILLIDEGREE 
>
> this solution has all your listed advantages and eliminates the  
> disadvantages I see in the "TEMP_DEGREE_TO_SYS" solution.

Well, yes, much better, in fact TEMP_DEGREE_TO_SYS is simple overengineering
(using a generic, _cryptic_ name in order to keep using it in the somewhat unlikely
case of having the factor change when you could just as well have mass-renamed
the couple places that use the macro name)

Andreas
