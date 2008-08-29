Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYH2IdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYH2IdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYH2IdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:33:03 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:51244 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYH2IdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:33:01 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: stefan_kopp@agilent.com
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round 2
Date: Fri, 29 Aug 2008 10:34:08 +0200
User-Agent: KMail/1.9.9
Cc: korgull@home.nl, greg@kroah.com, stern@rowland.harvard.edu,
       linux-usb@vger.kernel.org, me@felipebalbi.com,
       linux-kernel@vger.kernel.org
References: <20080827183615.GA15692@kroah.com> <200808290946.37898.oliver@neukum.org> <7D8F552F9FFBAC438A816966BEC4516BFBA389@cos-us-mb07.cos.agilent.com>
In-Reply-To: <7D8F552F9FFBAC438A816966BEC4516BFBA389@cos-us-mb07.cos.agilent.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291034.09307.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 29 August 2008 10:14:46 schrieb stefan_kopp@agilent.com:
> USBTMC has a different concept, the "termination character". If this is enabled and set to the appropriate character (usually /n), the read operation will be terminated by the device automatically. The last character in the response will be the termination character. Note, however, this capability is optional (not every vendor supports it) and even if it is supported, is might be deactivated (for good reason, e.g. for transfer of binary data).
> 
> If you are not using the termination character, the device will typically send its full output buffer contents. Usually, this works just fine because communication with the device is transactional, one query followed by a response, then another query, followed by another response, and so on.
> 
> The driver does return the number of characters received in both cases (with or without use of the term character feature).

But how do you learn in user space how many characters the device actually
did send? Using read() you'll only learn that the answer was shorter than
you asked for. If you get the amount you expected the answer may have
been as long as you expected or longer. How do you find out whether the answer
was longer?

	Regards
		Oliver
