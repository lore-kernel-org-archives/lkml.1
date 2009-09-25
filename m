Return-Path: <linux-kernel-owner+w=401wt.eu-S1751541AbZIYEeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbZIYEeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 00:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZIYEem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 00:34:42 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:37560 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZIYEel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 00:34:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pfdOOt0I5X+ILbNkaFTdw39DnF/lGaexVNjR8oIZMBtEYkTTl+d34jAa3p+/iEjaOv
         flibUXZoktPaTAoboNSrkFsO6gQkDlhFA2RkkCwrZBbrObMxgBTqdBca52Mpm7cPpDan
         zsFH9nmOghNH4NNv/hoFfjwgiO2Rgo5706nxs=
Date: Thu, 24 Sep 2009 21:34:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexandre Rostovtsev <tetromino@gmail.com>
Subject: Re: [PATCH] ACPI: New driver for Lenovo SL laptops
Message-ID: <20090925043441.GE416@core.coreip.homeip.net>
References: <1253805163-12493-1-git-send-email-ike.pan@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253805163-12493-1-git-send-email-ike.pan@canonical.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 11:12:43PM +0800, Ike Panhc wrote:
> +
> +static void hkey_inputdev_exit(void)
> +{
> +	if (hkey_inputdev) {
> +		input_unregister_device(hkey_inputdev);
> +		input_free_device(hkey_inputdev);

input_free_device() should not be called after input_unregister_device().

-- 
Dmitry
