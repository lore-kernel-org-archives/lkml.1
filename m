Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbZDFWQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbZDFWQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZDFWQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:16:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56677 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbZDFWQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:16:31 -0400
Message-ID: <49DA7F39.7090607@redhat.com>
Date: Mon, 06 Apr 2009 18:16:25 -0400
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: justinmattock@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: black screen with 2.6.29 on new imac
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 2.6.27 kernel had problems remapping EFI runtime on apple. That was 
fixed in 2.6.29-rc8. The 2.6.27 kernel will not boot on this hardware, 
it was not an X related issue.

You might try nvidiafb instead of efifb driver and see if that makes a 
difference. Im not sure if the X problem is related to the kernel.  I 
have not tackled the X issues yet.
Hope it helps.

Brian
