Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZFFHdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZFFHdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 03:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZFFHdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 03:33:24 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42437 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZFFHdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 03:33:24 -0400
Message-ID: <4A2A1AB6.9020808@cs.helsinki.fi>
Date: Sat, 06 Jun 2009 10:28:54 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, apw@canonical.com,
       colin.king@canonical.com, tim.gardner@canonicalc.com,
       bjorn.helgaas@hp.com
Subject: Re: [PATCH 2/2] pnp: add PNP resource range checking function
References: <Pine.LNX.4.64.0906060934500.11247@melkki.cs.Helsinki.FI> <200906060931.36168.elendil@planet.nl>
In-Reply-To: <200906060931.36168.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frans,

Frans Pop wrote:
>> Add a PNP resource range check function, indicating whether a resource
>> has been assigned to any device.
> 
> Shouldn't this patch come *before* your patch 1/2?
> You now seem to use this function in a commit where it has not yet been 
> defined, which could result in build errors during bisections.

Yes, correct. Sorry about that!

			Pekka
