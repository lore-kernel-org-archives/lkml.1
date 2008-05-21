Return-Path: <linux-kernel-owner+w=401wt.eu-S934831AbYEUNZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934831AbYEUNZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762701AbYEUNZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:25:14 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:33510 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbYEUNZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:25:12 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "vijay anand" <vijayanand.sj@gmail.com>
Subject: Re: [BUG] cdc-acm driver module
Date: Wed, 21 May 2008 15:25:07 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, dave@awk.cz
References: <b49af93b0805210601n38030150w643565b60edc85da@mail.gmail.com>
In-Reply-To: <b49af93b0805210601n38030150w643565b60edc85da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805211525.08054.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 21 Mai 2008 15:01:21 schrieb vijay anand:
> What happens when the control never reaches the 'acm_disconnect'. Like simply
> loading the driver and unloading the driver when the device is still in use.

Even in this case disconnect() will be called.
The only time it will not be called is if probe() was never called. But
in that case no interface has been claimed. All is well.

	Regards
		Oliver
