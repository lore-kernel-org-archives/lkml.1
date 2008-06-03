Return-Path: <linux-kernel-owner+w=401wt.eu-S1752136AbYFCHyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbYFCHyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 03:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYFCHyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 03:54:32 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:36007 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYFCHyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 03:54:31 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [Question] about modules/inline benefits
Date: Tue, 3 Jun 2008 09:54:41 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <4844C4D9.8030502@gawab.com> <g22rrs$6vp$1@ger.gmane.org>
In-Reply-To: <g22rrs$6vp$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806030954.42188.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 03 Juni 2008 09:28:59 schrieb Sitsofe Wheeler:
> Modules allow you to support more hardware as there is a maximum size of the
> core kernel image.

But you pay for every module with half a page of unused RAM and module
code will be in vmalloced memory thus increases TLB pressure a bit.

	Regards
		Oliver

