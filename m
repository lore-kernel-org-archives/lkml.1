Return-Path: <linux-kernel-owner+w=401wt.eu-S1751701AbXBVQqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbXBVQqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXBVQqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:46:00 -0500
Received: from terminus.zytor.com ([192.83.249.54]:40793 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbXBVQp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:45:59 -0500
Message-ID: <45DDC810.3000401@zytor.com>
Date: Thu, 22 Feb 2007 08:42:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -freg-struct-return?
References: <45DCF1C5.4030006@goop.org> <1172131463.3531.226.camel@laptopd505.fenrus.org> <45DD4FA0.5030205@goop.org> <20070222112207.GA10190@muc.de>
In-Reply-To: <20070222112207.GA10190@muc.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> I didn't think we had any that returned structures.
> 

Sometimes returning small structures is really nice.  If you can pass 
them in registers, it's often generates the fastest possible code; much 
better than using a pointer.

	-hpa
