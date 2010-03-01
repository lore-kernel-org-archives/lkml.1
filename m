Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab0CAP7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:59:06 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7152 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0CAP7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:59:04 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5907"; a="35171895"
Message-ID: <4B8BE42C.1090401@codeaurora.org>
Date: Mon, 01 Mar 2010 08:58:36 -0700
From: Jordan Crouse <jcrouse@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: dri-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: drm: Allow platform devices to register as DRM devices
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is a patch to allow platform devices on platforms without PCI 
to register and operate as fully fledged DRM devices.  I have been using 
this code for some time now and I'm convinced that the model works, but 
I'm posting this to get some constructive criticism on ways to improve 
the patch and get it ready for upstream.

Thanks,
Jordan

