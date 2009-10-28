Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbZJ1DUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbZJ1DUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932530AbZJ1DUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:20:39 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:37087 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519AbZJ1DUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:20:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DesDf+ftH+pNpfSFFWBXcTM1orhV7yQ8GwgL5GsjeuHvEoOHCNI6ThE/3l5hMgu/7b
         QMA66Kt7keLpeM7GHwXxuKfDkbrTT9PGHoS2WMbwtSNmx4ddY4Oao9T1HCFJj4xKPg0W
         fXtns0GQ6tOJCVgbyzGpJytkGWzTLjtZVYtDA=
Message-ID: <4AE7B887.6090806@gmail.com>
Date: Tue, 27 Oct 2009 23:20:39 -0400
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Andreas Petlund <apetlund@simula.no>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, ilpo.jarvinen@helsinki.fi, davem@davemloft.net
Subject: Re: [PATCH 2/3] net: TCP thin linear timeouts
References: <4AE72079.4030504@simula.no>
In-Reply-To: <4AE72079.4030504@simula.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to be too picky about the naming, but "rm_expb" really doesn't
mean what is actually done.  Perhaps TCP_THIN_LINEAR_BACKOFF and
sysctl_tcp_thin_linear_backoff?

Also, as debated on some other recent patches, shouldn't the global
sysctl specify the default, and the per socket option specify the
forced override?
