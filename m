Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbYH2Lb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbYH2Lb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYH2Lbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:31:49 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:43347 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbYH2Lbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:31:48 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: stefan_kopp@agilent.com
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round 2
Date: Fri, 29 Aug 2008 13:33:01 +0200
User-Agent: KMail/1.9.9
Cc: korgull@home.nl, greg@kroah.com, stern@rowland.harvard.edu,
       linux-usb@vger.kernel.org, me@felipebalbi.com,
       linux-kernel@vger.kernel.org
References: <20080827183615.GA15692@kroah.com> <200808291034.09307.oliver@neukum.org> <7D8F552F9FFBAC438A816966BEC4516BFBA3D0@cos-us-mb07.cos.agilent.com>
In-Reply-To: <7D8F552F9FFBAC438A816966BEC4516BFBA3D0@cos-us-mb07.cos.agilent.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291333.02113.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 29 August 2008 11:13:04 schrieb stefan_kopp@agilent.com:
> For large amounts of data (e.g. when downloading a waveform), USBTMC instruments often use a "binblock", a concept taken from the good old GPIB (IEEE488) standard, where the data is preceeded by a header and the header indicates how many bytes are following. So you first read and interpret the header and then you know exactly how many bytes to expect in the body of the message.

Not really ideal. We should tell user space how much really was sent.

	Regards
		Oliver

