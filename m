Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbYFETys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbYFETys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYFETyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:54:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58470 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYFETyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:54:38 -0400
Subject: Re: [PATCH 00/18] firmware: moving drivers to request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48483BA9.1070200@garzik.org>
References: <20080605.foo@pmac.infradead.org>  <48483BA9.1070200@garzik.org>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 20:54:35 +0100
Message-Id: <1212695675.32207.288.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 15:16 -0400, Jeff Garzik wrote:
> Why do we need the .ihex format?
> 
> We should be loading firmwares exactly as they come from the vendor, 
> without any wrappers.

It's just 'objcopy -Ibinary -Oihex foo foo.ihex'. It's purely for
convenience of handling the binary blobs in git (and it means we can
append licensing information after the EOF record too, if we want).

-- 
dwmw2

