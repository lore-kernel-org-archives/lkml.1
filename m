Return-Path: <linux-kernel-owner+w=401wt.eu-S1760806AbYELKAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806AbYELKAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757915AbYELKAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:00:35 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:34620 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932AbYELKAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:00:35 -0400
Message-ID: <48281540.9020207@grupopie.com>
Date: Mon, 12 May 2008 11:00:32 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.14 (X11/20071210)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: /proc/kallsyms broken in 2.6.26-rc1-git6
References: <20080509174148.GA22246@basil.nowhere.org> <482491D6.9030205@grupopie.com> <4824A7B6.70306@firstfloor.org> <4824AD3C.3070506@grupopie.com> <20080509233742.GA22265@martell.zuzino.mipt.ru>
In-Reply-To: <20080509233742.GA22265@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Fri, May 09, 2008 at 08:59:56PM +0100, Paulo Marques wrote:
>> Andi Kleen wrote:
>>>[...]
>>> Yes and? Surely that's not correct?
>> That's not for me to judge, but I believe it has always been like that.
> 
> *cough*
> 
> Here is how typical /proc/kallsyms looks like:
> 
> ffffffff80200000 A _text
> ffffffff80200000 T startup_64
> ffffffff802000b7 t ident_complete
> ffffffff80200100 T secondary_startup_64

This isn't helpful... the question is whether it is kallsyms misbehaving 
and placing new symbols in the kernel image or if it is some other 
change in the kernel that is generating new symbols that end up in the 
symbol table.

My guess it is that it is the later, and in that case, from a kallsyms 
standpoint "it has always been like that".

-- 
Paulo Marques - www.grupopie.com

"God is love. Love is blind. Ray Charles is blind. Ray Charles is God."
