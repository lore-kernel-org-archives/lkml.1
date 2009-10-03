Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbZJCSGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbZJCSGF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 14:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbZJCSGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 14:06:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:58558 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbZJCSGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 14:06:03 -0400
Date: Sat, 3 Oct 2009 11:05:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Matteo Croce <technoboy85@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091003110546.78958508@infradead.org>
In-Reply-To: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Oct 2009 04:12:47 +0200
Matteo Croce <technoboy85@gmail.com> wrote:
> 
> I also did this simple test which gives a ~2.5x speed boost:
> http://pastebin.ca/1590089

the number that is exposed in /proc/cpuinfo does not control
if cmov is used... so the patch and the benchmark are totally unrelated.

Anything that needs to know if cmov can be used will need to read the
flags line..

(since technically cmov is also optional for generation 6 and later)

While I can't say anything against your patch, I do need to say that it
is something purely cosmetic on first sight... 

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
