Return-Path: <linux-kernel-owner+w=401wt.eu-S1762308AbYEVLVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762308AbYEVLVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYEVLVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:21:41 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:59151 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbYEVLVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:21:40 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "vijay anand" <vijayanand.sj@gmail.com>
Subject: Re: [BUG] cdc-acm driver module
Date: Thu, 22 May 2008 13:21:36 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <b49af93b0805210601n38030150w643565b60edc85da@mail.gmail.com> <200805211525.08054.oliver@neukum.org> <b49af93b0805212159x46226c63i948e90e263283efc@mail.gmail.com>
In-Reply-To: <b49af93b0805212159x46226c63i948e90e263283efc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805221321.37063.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 22 Mai 2008 06:59:50 schrieb vijay anand:
> What happens when the function 'usb_deregister' in 'acm_exit'  gets
> called before the control reaches the 'acm_disconnect'? Is there any
> possibility for this? If yes what happens during this scenario?

This cannot happen. The driver core will disconnect all devices bound
to a driver to be unloaded.

	Regards
		Oliver

