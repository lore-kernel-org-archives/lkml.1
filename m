Return-Path: <linux-kernel-owner+w=401wt.eu-S1751729AbXBVRjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbXBVRjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:39:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbXBVRjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:39:05 -0500
Received: from gw.goop.org ([64.81.55.164]:46487 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbXBVRjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:39:04 -0500
Message-ID: <45DDD538.1040309@goop.org>
Date: Thu, 22 Feb 2007 09:39:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andi Kleen <ak@muc.de>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -freg-struct-return?
References: <45DCF1C5.4030006@goop.org> <1172131463.3531.226.camel@laptopd505.fenrus.org> <45DD4FA0.5030205@goop.org> <20070222112207.GA10190@muc.de> <45DDC810.3000401@zytor.com>
In-Reply-To: <45DDC810.3000401@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Sometimes returning small structures is really nice.  If you can pass
> them in registers, it's often generates the fastest possible code;
> much better than using a pointer. 

Yes, but specifically, are there any pieces of assembler which return
structures?  It appears there are none (since Ingo got a booting
kernel), but there might be something obscure in some corner.

    J
