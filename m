Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYKHPrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYKHPrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 10:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYKHPre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 10:47:34 -0500
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:56614 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbYKHPrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 10:47:33 -0500
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Nov 2008 10:47:33 EST
Date: Sat, 8 Nov 2008 16:41:55 +0100
From: The Peach <smartart@tiscali.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: kuroboxHG.dts compile FATAL ERROR on 2.6.26
Message-ID: <20081108164155.1327ff7b@tiscali.it>
In-Reply-To: <Pine.LNX.4.64.0811022011150.14486@axis700.grange>
References: <20081102132442.77e3bf93@tiscali.it>
	<Pine.LNX.4.64.0811022011150.14486@axis700.grange>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAABtQTFRFAAAACwsLMDAwT09PcXFxj4+PsLCw0dHR9/f3R+HqpwAAAAF0Uk5TAEDm2GYAAAINSURBVDjLzZRJd6JAFIU5Cva6CEiWDeKwZBDjkslhKQaUpYISlnEKrCPK+9ldpNVodN/9VnXuV6du1X3vFEH8J0Vq1mNgO/pDnTrUG9rDk2qxMnugV3QXVu/eA2K2IFOle91dpwAicXcYtWMBIAhHdxZiF4OMu9NH8wQflTcWd9b1XW+7cYzfPx+xFRTDsQRB//F6iq8JilozxvStOzXg1w2WUVZTmrolBreKnqtO1g1qN3o/SHf5cJDhe3HbaxBwcC6zcaV75PACPmdXJmUFK/nStnsxHOnvuCiiCUcT0YKAkBi3K995CH5I96OlF6W5y8vW+xl0xo645BEuWowhbF6aUkadENkF4CxzCMLZZFR+2df3G7wfph4EfpCdyNgEFgrwBHkHd/FTPFn/qkIH9tsuQm9JCzbVjFv+Tbz9kq7hMC28t8P8KU3ok/tc9rMuNB2EmgHMWweGjwpC6TIyUiVdfCjaR/NAQ2RpdPLVVNFg04w9DpLETOQWzHm/Xky3Xoo36Bk2zEKtTWQG8kXDn0s4yLEKexMPSIgEBTEpZAhfUdUJ8g23AgkxwE4R+kXu6xYAsyMixcdr9tIOONB401giyrJt2xavebjwSlUVROM8sYclqs5rW1RNSxQtx9Msu7x4DYsp13slUpfsEtWX3BIhuW6Z/ALL0YSszKQJRUxGEUXMiv5VKv/2m/gDf6ujKHNuVVwAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Nov 2008 20:15:21 +0100 (CET)
Guennadi wrote:

> Looks like you're using an old version of dtc. Try using dtc from the same 
> kernel from which .dts you're compiling:
> 
> linux-2.6/arch/powerpc/boot/dts$ ../dtc -I dts -O dtb -V 16 -o /tmp/kuroboxHG.dtb kuroboxHG.dts
> DTC: dts->dtb  on file "kuroboxHG.dts"
> 
sorry, I didn't notice dtc was "in bundle" with kernel sources.

question solved, thanks :)

-- 
Matteo 'Peach' Pescarin
