Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbYH2Hpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbYH2Hpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYH2HpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:45:25 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:39630 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbYH2HpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:45:24 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: stefan_kopp@agilent.com
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round 2
Date: Fri, 29 Aug 2008 09:46:36 +0200
User-Agent: KMail/1.9.9
Cc: korgull@home.nl, greg@kroah.com, stern@rowland.harvard.edu,
       linux-usb@vger.kernel.org, me@felipebalbi.com,
       linux-kernel@vger.kernel.org
References: <20080827183615.GA15692@kroah.com> <200808281858.42486.korgull@home.nl> <7D8F552F9FFBAC438A816966BEC4516BFBA328@cos-us-mb07.cos.agilent.com>
In-Reply-To: <7D8F552F9FFBAC438A816966BEC4516BFBA328@cos-us-mb07.cos.agilent.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808290946.37898.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 29 August 2008 08:57:54 schrieb stefan_kopp@agilent.com:
> The issue with using cat on the shell level is that it uses fread which has the (in this case) ugly behaviour of recalling the driver's read method until the full number of characters requested has been accumulated (or until zero characters are returned, indicating the end of file). With USBTMC instruments, this behavour is bad because the retry

This may be problematic. The driver is throwing away EOF in other words.
Generally this is not a good idea. User space can no longer tell how long the
reply was.

	Regards
		Oliver

