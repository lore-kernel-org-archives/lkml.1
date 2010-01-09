Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555Ab0AIAPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0AIAPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521Ab0AIAPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:15:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41109 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab0AIAPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:15:48 -0500
Message-ID: <4B47C984.1080903@zytor.com>
Date: Fri, 08 Jan 2010 16:10:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Arjan van de Ven <arjan@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: strict copy_from_user checks issues?
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com> <201001071502.29777.arnd@arndb.de> <4B4674FF.5070700@zytor.com> <201001090107.43402.arnd@arndb.de>
In-Reply-To: <201001090107.43402.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2010 04:07 PM, Arnd Bergmann wrote:
> 
> Also, the calling conventions require you to write slightly more when
> you want to pass down an error value, e.g.
> 
> 	return copy_to_user(uptr, &data, sizeof(data)) ? -EFAULT : 0;
> 
> instead of
> 
> 	return put_user(data, uptr);
> 
> The latter form requires a macro instead of a function for the user copy,
> but we now have that anyway because of the size check.
> 

Well... we already have the latter form?

	-hpa

